
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :native) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |touch-control/ |pointed-prompt/ |quatrefoil/ |quaternion/ |js-ffi/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (store)
            let
                states $ decode-map-as (field store :states) (:: 'Map 'Tag 'Dynamic)
                scaled 0.02
              scene ({})
                group
                  {}
                    :scale $ [] scaled scaled scaled
                    :position $ [] -0.2 1.2 -0.2
                  comp-helicoid $ decode-map-as (>> states :helicoid) (:: 'Map 'Tag 'Dynamic)
                  ambient-light $ {} (:color 0x666666) (:intensity 6)
                  point-light $ {} (:color 0xffffff) (:intensity 1.4) (:distance 200)
                    :position $ [] 20 40 50
                  point-light $ {} (:color 0xffffff) (:intensity 2) (:distance 200)
                    :position $ [] 0 60 0
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'quatrefoil.schema/Component)
            :args $ [] $ :: 'Map 'Tag 'Dynamic
            :features $ #{} :js-ffi
        'field $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn field (value key)
            .unwrap-or (get value key) nil
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ [] (:: 'Map 'Tag 'Dynamic) 'Tag
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            quatrefoil.alias :refer $ group box sphere point-light ambient-light scene text
            quatrefoil.core :refer $ defcomp >>
            app.comp.helicoid :refer $ comp-helicoid
    'app.comp.helicoid $ %{} 'FileEntry
      :defs $ {}
        'as-number $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn as-number (value) (decode-map-as value 'Number)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'comp-helicoid $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-helicoid (states)
            let
                cursor $ field states :cursor
                state $ decode-map-as
                  or (field states :data)
                    {} (:speed 48) (:bend 0) (:radius 20)
                  :: 'Map 'Tag 'Number
              group ({})
                tube $ {} (:points-fn helicoid-fn) (:factor state) (:radius 0.2) (:tubular-segments 800) (:radial-segments 12)
                  :position $ [] 0 0 0
                  :material $ {} (:kind :mesh-standard) (:color 0xcccc77) (:opacity 1) (:transparent true)
                tube $ {} (:points-fn helicoid-fn-2) (:factor state) (:radius 0.2) (:tubular-segments 400) (:radial-segments 12)
                  :position $ [] 0 0 0
                  :material $ {} (:kind :mesh-standard) (:color 0xcccc77) (:opacity 1) (:transparent true)
                parametric $ {} (:func surface-fn) (:data state) (:slices 100) (:stacks 100)
                  :position $ [] 0 0 0
                  :material $ {} (:kind :mesh-lambert) (:opacity 0.8) (:transparent true) (:color 0x5e5ed5)
                point-light $ {} (:color 0xffffff) (:intensity 2) (:distance 200)
                  :position $ [] 20 40 50
                ; comp-control state cursor :speed ([] 40 10 0) 0.3 ([] 0 100) 0xffffdd
                comp-value
                  {} (:speed 0.3) (:show-text? true) (:label |speed)
                    :value $ .unwrap $ get state :speed
                    :position $ [] 40 10 0
                    :bound $ [] 0 100
                    :color 0xffffdd
                  fn (v1 d!)
                    hint-fn $ {}
                      :args $ [] 'Dynamic $ :: 'Fn
                        {}
                          :args $ [] 'Dynamic 'Dynamic
                          :return 'Unit
                      :return 'Unit
                    d! cursor $ assoc state :speed $ as-number v1
                comp-value
                  {} (:speed 0.01) (:show-text? true) (:label |bend)
                    :value $ .unwrap $ get state :bend
                    :position $ [] 48 10 0
                    :bound $ [] 0 10
                    :color 0xaaaaff
                  fn (v1 d!)
                    hint-fn $ {}
                      :args $ [] 'Dynamic $ :: 'Fn
                        {}
                          :args $ [] 'Dynamic 'Dynamic
                          :return 'Unit
                      :return 'Unit
                    d! cursor $ assoc state :bend $ as-number v1
                comp-value
                  {} (:speed 0.4) (:show-text? true) (:label |radius)
                    :value $ .unwrap $ get state :radius
                    :position $ [] 56 10 0
                    :bound $ [] 1 60
                    :color 0xaa7777
                  fn (v1 d!)
                    hint-fn $ {}
                      :args $ [] 'Dynamic $ :: 'Fn
                        {}
                          :args $ [] 'Dynamic 'Dynamic
                          :return 'Unit
                      :return 'Unit
                    d! cursor $ assoc state :radius $ as-number v1
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'quatrefoil.schema/Component)
            :args $ [] $ :: 'Map 'Tag 'Dynamic
            :features $ #{} :js-ffi
        'field $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn field (value key)
            .unwrap-or (get value key) nil
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ [] (:: 'Map 'Tag 'Dynamic) 'Tag
        'helicoid-fn $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn helicoid-fn (t state)
            let
                r $ .unwrap $ get state :radius
                v $ .unwrap $ get state :speed
                bend $ .unwrap $ get state :bend
                angle $ * t &PI
                rot-angle $ * v $ squeezing-01 t
              rotate-wave (- t 0.5) bend $ []
                * r (sin angle) (cos rot-angle)
                * r $ cos angle
                * r (sin angle) (sin rot-angle)
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Number $ :: 'Map 'Tag 'Number
            :return $ :: 'List 'Number
        'helicoid-fn-2 $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn helicoid-fn-2 (t state)
            let
                r $ .unwrap $ get state :radius
                v $ .unwrap $ get state :speed
                bend $ .unwrap $ get state :bend
                angle $ * t &PI
                rot-angle $ + &PI $ * v (squeezing-01 t)
              rotate-wave (- t 0.5) bend $ []
                * r (sin angle) (cos rot-angle)
                * r $ cos angle
                * r (sin angle) (sin rot-angle)
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Number $ :: 'Map 'Tag 'Number
            :return $ :: 'List 'Number
        'math-asin $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn math-asin (x)
            as-number $ js/Math.asin x
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'Number
            :features $ #{} :js-ffi
        'math-tan $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn math-tan (x)
            as-number $ js/Math.tan x
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'Number
            :features $ #{} :js-ffi
        'quaternion-position $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn quaternion-position (value)
            match value $
              :quaternion s x y z
              [] x y z s
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'quaternion.core/Quaternion
            :return $ :: 'List 'Number
        'rotate-wave $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn rotate-wave (dx bend v)
            let
                x $ .unwrap $ nth v 0
                y $ .unwrap $ nth v 1
                z $ .unwrap $ nth v 2
                q1 $ quaternion 0 x y z
                angle $ * bend &PI dx
                half-angle $ * 0.5 angle
                q2 $ quaternion (cos half-angle) (sin half-angle) 0 0
                ret $ &q*
                  &q* (q-inverse q2) q1
                  , q2
              quaternion-position ret
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Number 'Number $ :: 'List 'Number
            :return $ :: 'List 'Number
          :tests $ [] $ %{} 'TestEntry (:name |identity-rotation)
            :code $ quote $ do
              assert= ([] 1 2 3 0)
                rotate-wave 0.2 0 $ [] 1 2 3
              assert= ([] 1 2 3 0)
                rotate-wave 0 2 $ [] 1 2 3
            :tags $ #{} :geometry
        'squeezing-01 $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn squeezing-01 (t0)
            + 0.5 $ /
              math-asin $ - (* 2 t0) 1
              , &PI
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'Number
        'surface-fn $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn surface-fn (t d state)
            let
                r $ .unwrap $ get state :radius
                v $ .unwrap $ get state :speed
                bend $ .unwrap $ get state :bend
                angle $ * t &PI
                rot-angle $ * v $ squeezing-01 t
                out-r $ * r $ math-tan angle
                distance $ / r $ cos angle
                y0 $ - r distance
                angle2 $ - (* 0.5 &PI) angle
                theta $ * 2 angle2 $ - d 0.5
                narrow? $ < (abs angle2) 0.001
                dx $ if narrow?
                  * 2 r $ - d 0.5
                  * r (math-tan angle) (sin theta)
                dy $ if narrow? r $ + y0
                  * r (math-tan angle) (cos theta)
              rotate-wave (- t 0.5) bend $ []
                * dx $ cos rot-angle
                - r dy
                * dx $ sin rot-angle
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Number 'Number $ :: 'Map 'Tag 'Number
            :return $ :: 'List 'Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.helicoid
          :require
            quatrefoil.alias :refer $ group box sphere text line tube point-light parametric
            quatrefoil.core :refer $ defcomp
            quatrefoil.comp.control :refer $ comp-value
            quaternion.core :refer $ &q* q-inverse quaternion
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *store
            {} $ :states $ {}
              :cursor $ []
          :examples $ []
          :schema $ :: 'Ref $ :: 'Map 'Tag 'Dynamic
        'MobileDetectHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait MobileDetectHost
            .mobile? $ :: 'Fn $ {}
              :args $ [] 'app.main/MobileDetectHost
              :return $ :: 'JsNullish 'String
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} $ :mobile? |mobile
          :schema $ :: 'Trait
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op op-data)
            if (list? op)
              recur :states $ [] op op-data
              let
                  store $ updater @*store op op-data
                ; js/console.log |Dispatch: op op-data store
                reset! *store store
                , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Dynamic 'Dynamic
            :features $ #{} :js-ffi
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! () (load-console-formatter!) (inject-tree-methods)
            set-perspective-camera! $ {} (:fov 40) (:near 0.1) (:far 100)
              :position $ [] 0 0 8
              :aspect $ / (viewport-width) (viewport-height)
            let
                canvas-el $ .unwrap $ query-selector |canvas
              init-renderer! canvas-el $ {} $ :background 0x110022
            render-app!
            add-watch! *store :changes $ fn (store prev) (render-app!)
            set! js/window.onkeydown handle-key-event
            render-control!
            handle-control-events
            init-controls!
            println |App-started!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mobile? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn mobile? ()
            let
                detector $ js-cast (new mobile-detect js/window.navigator.userAgent) 'app.main/MobileDetectHost
              js-present? $ detector .mobile?
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (non-nil? build-errors) (hud! |error build-errors)
              do (hud! |ok~ nil) (clear-cache!)
                when (mobile?) (clear-control-loop!) (handle-control-events)
                remove-watch! *store :changes
                add-watch! *store :changes $ fn (store prev) (render-app!)
                render-app!
                set! js/window.onkeydown handle-key-event
                println |Code-updated.
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! () (; println "|Render app:")
            render-canvas! (comp-container @*store) dispatch!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            |@quamolit/quatrefoil-utils :refer $ inject-tree-methods
            quatrefoil.core :refer $ render-canvas! *global-tree init-controls! clear-cache! init-renderer! handle-key-event handle-control-events
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            |three :as THREE
            touch-control.core :refer $ render-control! control-states start-control-loop! clear-control-loop!
            |mobile-detect :default mobile-detect
            |bottom-tip :default hud!
            |./calcit.build-errors :default build-errors
            quatrefoil.dsl.object3d-dom :refer $ set-perspective-camera!
            js-ffi.browser :refer $ viewport-width viewport-height query-selector
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-data)
            match op
              :states $ update-states store op-data
              _ store
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] (:: 'Map 'Tag 'Dynamic) 'Dynamic 'Dynamic
            :return $ :: 'Map 'Tag 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ quatrefoil.cursor :refer $ update-states
