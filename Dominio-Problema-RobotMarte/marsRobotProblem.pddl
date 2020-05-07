(define (problem marsRobotProblem)
    (:domain marsRobotDomain)
    (:objects 
            r - robot
            P0335 P1515 P0521 P1507 P2520 P3535 - place
            photop1 photop2 photop3t1 photop3t2 photop3t3 dataearthp2 dataearthp6t1 dataearthp6t2 - task
    )

    (:init
        (connected P0335 P1515) (connected P1515 P0335)
        (connected P1515 P0521) (connected P0521 P1515)
        (connected P0521 P1507) (connected P1507 P0521)
        (connected P1507 P2520) (connected P2520 P1507)
        (connected P2520 P3535) (connected P3535 P2520)
        (at-robot r P0335)
        (still r)
        (solar-panel-closed r)

        ;En un grid de 40x40 consideramos que estamos en un espacio de 400x400 metros
        ;Las distancias entre los puntos están expresadas en metros.
        ;Autonomía máxima del robot: 300 metros sin violar el límite de 40% minimo de bateria
        (= (distance P0335 P1515) 230) 
        (= (distance P1515 P0521) 120)
        (= (distance P0521 P1507) 170)
        (= (distance P1507 P2520) 160)
        (= (distance P2520 P3535) 180)

        (= (speed r) 30)
        (= (battery-level r) 100)
        (= (max-battery-level r) 100)
        (= (battery-threshold r) 40)
        (= (battery-consumption-rate r) 0.2)
        (= (taking-photo-duration r) 2)
        (= (drilling-time r) 5)
        (= (analyse-time r) 30)
        (= (transmitting-time r) 5)
        (= (solar-panel-setup-time r) 2)
        (= (recharge-rate r) 3)
        (= (total-battery-used r) 0)
    )

    (:goal
        (and
            (at-robot r P3535)
            (data-on-earth P1515 dataearthp2)
            (data-on-earth P3535 dataearthp6t1)
            (data-on-earth P3535 dataearthp6t2)
            (have-photo r P0335 photop1)
            (have-photo r P1515 photop2)
            (have-photo r P0521 photop3t1)
            (have-photo r P0521 photop3t2)
            (have-photo r P0521 photop3t3)
        )
    )
    (:metric minimize (total-battery-used r))
)
