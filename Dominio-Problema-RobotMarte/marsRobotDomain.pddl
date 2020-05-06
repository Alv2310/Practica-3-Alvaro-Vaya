;Importante: el tiempo lo medimos en minutos
(define (domain marsRobotDomain)

    (:requirements  :durative-actions 
                    :fluents 
                    :typing 
                    :constraints 
                    :preferences
                    :universal-preconditions)

    (:types robot place task)

    (:predicates
        (moving ?r - robot)
        (still ?r - robot)
        (connected ?p1 ?p2 - place)
        (at-robot ?r - robot ?p - place)
        (solar-panel-opened ?r - robot)
        (solar-panel-closed ?r - robot)
        (have-photo ?r - robot ?p - place ?t - task)
        (have-sample ?r - robot ?p - place)
        (place-analysed ?p - place)
        (data-on-earth ?p - place ?t - task)
    )

    (:functions
        (distance ?p1 ?p2 - place);En metros
        (slow-speed ?r - robot);En metros/minuto
        (fast-speed ?r - robot);En metros/minuto
        (battery-level ?r - robot);de 0 a 100
        (max-battery-level ?r - robot);100
        (battery-threshold ?r - robot)
        (fast-battery-consumption-rate ?r - robot);%bateria/metro
        (slow-battery-consumption-rate ?r - robot) ;%bateria/metro
        (taking-photo-duration ?r - robot);Minutos
        (drilling-time ?r - robot);Minutos
        (analyse-time ?r - robot);Minutos
        (transmitting-time ?r - robot);Minutos
        (solar-panel-setup-time ?r - robot);Minutos
        (recharge-rate ?r - robot);%bateria/minuto
        (total-battery-used ?r - robot) 
    )

    (:durative-action move-slow
        :parameters (?r - robot ?p1 ?p2 - place)
        :duration (= ?duration (/ 
                                (distance ?p1 ?p2)
                                (slow-speed ?r)
                                )
                    )
        :condition (and 
            (at start (still ?r))
            (at start (at-robot ?r ?p1))
            (over all (connected ?p1 ?p2))
            (over all (solar-panel-closed ?r))
            (over all 
                (>= 
                    (-
                        (battery-level ?r)
                        (*
                            (distance ?p1 ?p2)
                            (slow-battery-consumption-rate ?r)
                        )
                    )
                    (battery-threshold ?r)
                )
            )
        )

        :effect (and 
            (at start (not (at-robot ?r ?p1)))
            (at end (at-robot ?r ?p2))
            (at start (moving ?r))
            (at start (not (still ?r)))
            (at end (not (moving ?r)))
            (at end (still ?r))
            (at end (decrease 
                        (battery-level ?r)         
                        (*
                            (distance ?p1 ?p2)
                            (slow-battery-consumption-rate ?r)
                        )
                    )
            )
            (at end (increase 
                            (total-battery-used ?r) 
                            (*
                                (distance ?p1 ?p2)
                                (slow-battery-consumption-rate ?r)
                            )
                        )
            )
        )
    )

    (:durative-action move-fast
        :parameters (?r - robot ?p1 ?p2 - place)
        :duration (= ?duration (/ 
                                (distance ?p1 ?p2)
                                (fast-speed ?r)
                                )
                    )
        :condition (and 
            (at start (still ?r))
            (at start (at-robot ?r ?p1))
            (over all (connected ?p1 ?p2))
            (over all (solar-panel-closed ?r))
            (over all 
                (>= 
                    (-
                        (battery-level ?r)
                        (*
                            (distance ?p1 ?p2)
                            (fast-battery-consumption-rate ?r)
                        )
                    )
                    (battery-threshold ?r)
                )
            )
        )

        :effect (and 
            (at start (not (at-robot ?r ?p1)))
            (at end (at-robot ?r ?p2))
            (at start (moving ?r))
            (at start (not (still ?r)))
            (at end (not (moving ?r)))
            (at end (still ?r))
            (at end (decrease 
                        (battery-level ?r)
                        (*
                            (distance ?p1 ?p2)
                            (fast-battery-consumption-rate ?r)
                        )
                    )
            )
            (at end (increase 
                            (total-battery-used ?r) 
                            (*
                                (distance ?p1 ?p2)
                                (slow-battery-consumption-rate ?r)
                            )
                        )
            )
        )
    )

    (:durative-action take-photo
        :parameters (?r - robot ?p - place ?t - task)
        :duration (= ?duration (taking-photo-duration ?r))
        :condition (and 
            (over all (still ?r))
            (over all (at-robot ?r ?p))
            (over all (solar-panel-closed ?r))
        )
        :effect (and
            (at end (have-photo ?r ?p ?t))
        )
    )
    
     (:durative-action drill
        :parameters (?r - robot ?p - place)
        :duration (= ?duration (drilling-time ?r))
        :condition (and 
            (over all (still ?r))
            (over all (at-robot ?r ?p))
            (over all (solar-panel-closed ?r))
        )
        :effect (and
            (at end (have-sample ?r ?p))
        )
     )

     (:durative-action analyse-sample
        :parameters (?r - robot ?p - place)
        :duration (= ?duration (analyse-time ?r))
        :condition (and 
            (over all (still ?r))
            (over all (at-robot ?r ?p))
            (over all (solar-panel-closed ?r))
            (at start (have-sample ?r ?p))
        )
        :effect (and 
            (at end (place-analysed ?p))    
            (at end (not (have-sample ?r ?p)))        
        )
     )

     (:durative-action transmit-place-analysed
        :parameters (?r - robot ?p - place ?t - task)
        :duration (= ?duration (transmitting-time ?r))
        :condition (and 
            (over all (still ?r))
            (over all (at-robot ?r ?p))
            (over all (solar-panel-closed ?r))
            (at start (place-analysed ?p))
        )
        :effect (and 
            (at end (data-on-earth ?p ?t))
            (at end (not (place-analysed ?p)))
        )
     )

     (:durative-action open-solar-panel
        :parameters (?r - robot ?p - place)
        :duration (= ?duration (solar-panel-setup-time ?r))
        :condition (and 
            (over all (still ?r))
            (over all (at-robot ?r ?p))
            (at start (solar-panel-closed ?r))
        )
        :effect (and
            (at start (not (solar-panel-closed ?r)))
            (at end (solar-panel-opened ?r))            
        )
     )

     (:durative-action close-solar-panel
        :parameters (?r - robot ?p - place)
        :duration (= ?duration (solar-panel-setup-time ?r))
        :condition (and 
            (over all (still ?r))
            (over all (at-robot ?r ?p))
            (at start (solar-panel-opened ?r))
        )
        :effect (and
            (at start (not (solar-panel-opened ?r)))
            (at end (solar-panel-closed ?r))
        )
     )

     (:durative-action recharge
        :parameters (?r - robot ?p - place)
        :duration (= ?duration (/
                                (- 
                                    (max-battery-level ?r)
                                    (battery-level ?r)
                                )
                                (recharge-rate ?r)
                                )
        )

        :condition (and 
            (over all (still ?r))
            (over all (at-robot ?r ?p))
            (over all (solar-panel-opened ?r))
            (at start (<
                        (battery-level ?r)
                        (max-battery-level ?r)
                        )
            )
        )
        :effect (at end (assign (battery-level ?r) (max-battery-level ?r)))
     )     
)