(defn magnitude [vector]
  (math/sqrt (sum (map |(* $ $) vector))))

(defn straight-line [v1 v2]
  (magnitude (map - v1 v2)))

(with [f (file/open "2025/8/ex_input")]
  (def parsed (freeze (map
    |(map parse (string/split "," (string/trim $)))
    (file/lines f))))
  (loop [i :range [0 (length parsed)]
        :after (print)
         j :range [0 i]]
    (let [v1 (get parsed i)
          v2 (get parsed j)]
    (pp (straight-line v1 v2)))))
