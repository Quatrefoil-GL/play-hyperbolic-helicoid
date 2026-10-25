import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {readFileSync,writeFileSync,mkdirSync} from 'node:fs';
assert.equal(process.env.GITHUB_ACTIONS,'true');assert.equal(process.platform,'linux');
const p=JSON.parse(readFileSync('reviewed-source.json'));
assert.ok(['torus','helicoid'].includes(p.name));
const run=(exe,args)=>execFileSync(exe,args,{encoding:'utf8',maxBuffer:32e6,stdio:['pipe','pipe','pipe']});
assert.equal(run('calcit',['-v']).trim(),'0.30.1');
const norm=v=>Array.isArray(v)?v.map(norm):v&&typeof v==='object'?Object.fromEntries(Object.entries(v).map(([k,x])=>[k,k==='__edn_set'?x.map(norm).sort((a,b)=>JSON.stringify(a).localeCompare(JSON.stringify(b))):k==='schema'&&Array.isArray(x)&&x[0]==='{}'?['{}',...x.slice(1).map(norm).sort((a,b)=>a[0].localeCompare(b[0]))]:norm(x)])):v;
const q=(...args)=>{const r=JSON.parse(run('calcit',['query',...args,'--format','json']));assert.ok(!r.diagnostics?.some(d=>d.severity==='error'));return norm(r.data);};
function views(){const namespaces=[],defs=[];for(const ns of q('ns').namespaces){const n=q('ns',ns);namespaces.push(n);const names=run('calcit',['query','defs',ns]).split('\n').filter(l=>/^  \S/.test(l)).map(l=>l.trim().split(' ')[0]);assert.equal(names.length,n.definition_count);for(const name of names)defs.push(q('def',ns+'/'+name));}return {config:q('config'),namespaces,defs};}
mkdirSync('acceptance',{recursive:true});
if(process.argv[2]==='replay'){
 const stage=process.argv[3];assert.ok(['before','after'].includes(stage));
 const snippet=`let
    store $ {} (:states $ {} (:cursor $ []) (:retained $ {} (:data |keep))) (:extra |keep)
    payload $ [] ([] :panel) ({} (:value 2))
  assert= (quatrefoil.cursor/update-states store payload) $ app.updater/updater store :states payload
  assert= store $ app.updater/updater store :unknown nil
  assert= store $ app.updater/updater store |states nil
  assert= store $ app.updater/updater store nil nil
  assert= store $ app.updater/updater store 42 nil
  assert= store $ app.updater/updater store true nil
  assert= store $ app.updater/updater store ([] :states) nil
  assert= store $ app.updater/updater store ({} (:value 2)) nil
  assert= store $ app.updater/updater store (:: :states) nil
  println |dispatch-native-ok`;
 const before=run('git',['hash-object','calcit.cirru']).trim();
 assert.equal(q('def','app.updater/updater').tests.length,0);
 const testCode='quote $ '+snippet.replaceAll('app.updater/updater','updater').replaceAll('quatrefoil.cursor/update-states','update-states');
 run('calcit',['edit','add-test','app.updater/updater','migration-dispatch-replay','--input-format','cirru','--code',testCode]);
 try{const raw=run('calcit',['test','app.updater/updater','--require-match','--format','json']);const t=JSON.parse(raw);assert.equal(t.selected,1);assert.equal(t.executed,1);assert.equal(t.passed,1);assert.equal(t.failed,0);writeFileSync('acceptance/native-'+stage+'.log','dispatch-native-ok\n');writeFileSync('acceptance/native-'+stage+'.json',raw);}
 finally{run('calcit',['edit','rm-test','app.updater/updater','migration-dispatch-replay']);assert.equal(run('git',['hash-object','calcit.cirru']).trim(),before);}
 writeFileSync('acceptance/js-'+stage+'.json',run('node',['check-dispatch.mjs']));process.exit(0);
}
if(process.argv[2]==='gates'){
 writeFileSync('acceptance/original-test.json',run('calcit',['test',p.test,'--require-match','--format','json']));
 writeFileSync('acceptance/public.json',run('calcit',['--check-only',...p.publicNamespaces.flatMap(ns=>['--ns',ns]),'--summary-only','--format','json']));
 for(const[kind,args]of [['coverage',['--only','coverage']],['unresolved',['--only','schema-dynamic,code-dynamic','--intent','unresolved']],['deprecated',['--only','deprecated-call']],['dynamic-method',['--only','dynamic-method']]]){const raw=run('calcit',['analyze','weak-types',...args,'--summary-only','--format','json']);writeFileSync('acceptance/'+kind+'.json',raw);if(kind==='dynamic-method')assert.equal(JSON.parse(raw).data.summary.findings,0);}
 process.exit(0);
}
const expected=norm(structuredClone(p.before));assert.equal(expected.defs.length,p.definitions);
const store=expected.defs.find(d=>d.id==='app.main/*store');assert.equal(store.code[0],'defatom');store.code[0]='defref';
const updater=expected.defs.find(d=>d.id==='app.updater/updater');assert.deepEqual(updater.code[3],['case-default','op','store',[':states',['update-states','store','op-data']]]);
updater.code[3]=['match','op',[':states',['update-states','store','op-data']],['_','store']];
const operations=[['tree','replace',store.id,'--path','@0','--input-format','json-ast','--code','"defref"'],['tree','replace',updater.id,'--path','@3','--input-format','json-ast','--code',JSON.stringify(updater.code[3])]];
const blob=()=>run('git',['hash-object','calcit.cirru']).trim();
if(process.argv[2]==='apply'){
 assert.equal(blob(),p.blob);assert.deepEqual(views(),norm(p.before));
 writeFileSync('acceptance/expected-source.json',JSON.stringify(expected));writeFileSync('acceptance/operations.json',JSON.stringify(operations));
 const args=['edit','transaction','--file','acceptance/operations.json','--format','json'];const dry=JSON.parse(run('calcit',[...args,'--dry-run']));assert.ok(dry.scoped_revision);
 writeFileSync('acceptance/preview.json',JSON.stringify(dry));writeFileSync('acceptance/applied.json',run('calcit',[...args,'--expect-revision',dry.scoped_revision]));writeFileSync('acceptance/modified-blob.txt',blob());
}else assert.equal(process.argv[2],'verify');
const actual=views();assert.deepEqual(actual,expected);assert.equal(blob(),readFileSync('acceptance/modified-blob.txt','utf8'));writeFileSync('acceptance/actual-source.json',JSON.stringify(actual));
for(const[file,hash]of Object.entries(p.ordinaryBlobs))assert.equal(run('git',['hash-object',file]).trim(),hash,'unexpected ordinary file mutation: '+file);
if(process.argv[2]==='verify'){
 const manifest=name=>new Map(readFileSync('acceptance/'+name+'-js.sha256','utf8').trim().split('\n').map(line=>{const m=line.match(/^([a-f0-9]{64})  (.+)$/);assert.ok(m);return[m[2],m[1]];}));
 const before=manifest('before'),after=manifest('after');assert.ok(before.size>0);assert.deepEqual([...before.keys()],[...after.keys()]);
 const changed=[...before.keys()].filter(file=>before.get(file)!==after.get(file));assert.ok(changed.every(file=>file==='js-out/app.updater.mjs'));
 const t=JSON.parse(readFileSync('acceptance/original-test.json'));assert.equal(t.selected,1);assert.equal(t.executed,1);assert.equal(t.passed,1);assert.equal(t.failed,0);
 for(const stage of ['before','after']){const j=JSON.parse(readFileSync('acceptance/js-'+stage+'.json'));assert.equal(j.passed,9);assert.ok(readFileSync('acceptance/native-'+stage+'.log','utf8').includes('dispatch-native-ok'));}
 writeFileSync('acceptance/generated-js-evidence.json',JSON.stringify({files:before.size,changed,otherFilesIdentical:true,nativeCasesPerStage:9,jsCasesPerStage:9}));
}
writeFileSync('acceptance/source-evidence.json',JSON.stringify({stage:process.argv[2],before:p.blob,after:blob(),definitions:expected.defs.length,namespaces:expected.namespaces.length,operations,completeViewsMatch:true,allOriginalOrdinaryFilesUnchanged:true}));
