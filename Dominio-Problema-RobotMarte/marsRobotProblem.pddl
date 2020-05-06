(define (problem marsRobotProblem)
    (:domain marsRobotDomain)
    (:objects 
            explorer - robot
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
        (at-robot explorer p1)
        (still explorer)
        (solar-panel-closed explorer)

        (= (distance p1 p2) 200) 
        (= (distance p2 p3) 40)
        (= (distance p3 p4) 90)
        (= (distance p4 p5) 300)
        (= (distance p5 p6) 50)

        (= (speed explorer) 30)
        (= (battery-level explorer) 100)
        (= (max-battery-level explorer) 100)
        (= (battery-threshold explorer) 40)
        (= (battery-consumption-rate explorer) 0.2)
        (= (taking-photo-duration explorer) 2)
        (= (drilling-time explorer) 5)
        (= (analyse-time explorer) 30)
        (= (transmitting-time explorer) 5)
        (= (solar-panel-setup-time explorer) 2)
        (= (recharge-rate explorer) 3)
        (= (total-battery-used explorer) 0)
    )

    (:goal
        (and
            (at-robot explorer p6)
            (data-on-earth p2 dataearthp2)
            (data-on-earth p6 dataearthp6t1)
            (data-on-earth p6 dataearthp6t2)
            (have-photo explorer p1 photop1)
            (have-photo explorer p2 photop2)
            (have-photo explorer p3 photop3t1)
            (have-photo explorer p3 photop3t2)
            (have-photo explorer p3 photop3t3)
        )
    )
    (:metric minimize (total-battery-used explorer))
)