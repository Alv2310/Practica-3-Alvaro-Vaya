(define (problem marsRobotProblem)
    (:domain marsRobotDomain)
    (:objects 
            r - robot
            p1 p2 p3 p4 p5 p6 - place
            photop1 photop2 photop3t1 photop3t2 photop3t3 dataearthp2 dataearthp6t1 dataearthp6t2 - task
    )

    ;El ratio de gasto de bateria esta calculado para que el robot, en el modo mas ahorrador (yendo a velocidad lenta)
    ;pueda recorrer como maximo 300 metros (asi obligamos a recargar para ir de p4 a p5 y una vez llegado a p5 obligamos
    ;a recargar otra vez antes de hacer otra accion)
    (:init
        (connected p1 p2) (connected p2 p1)
        (connected p2 p3) (connected p3 p2)
        (connected p3 p4) (connected p4 p3)
        (connected p4 p5) (connected p5 p4)
        (connected p5 p6) (connected p6 p5)
        (at-robot r p1)
        (still r)
        (solar-panel-closed r)

        (= (distance p1 p2) 200) 
        (= (distance p2 p3) 40)
        (= (distance p3 p4) 90)
        (= (distance p4 p5) 300)
        (= (distance p5 p6) 50)

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
            (at-robot r p6)
            (data-on-earth p2 dataearthp2)
            (data-on-earth p6 dataearthp6t1)
            (data-on-earth p6 dataearthp6t2)
            (have-photo r p1 photop1)
            (have-photo r p2 photop2)
            (have-photo r p3 photop3t1)
            (have-photo r p3 photop3t2)
            (have-photo r p3 photop3t3)
        )
    )
    (:metric minimize (total-battery-used r))
)