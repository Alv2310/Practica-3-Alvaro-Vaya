import path_planning as pp
import math as m

def children(point,grid):
    """
        Calculates the children of a given node over a grid.
        Inputs:
            - point: node for which to calculate children.
            - grid: grid over which to calculate children.
        Outputs:
            - list of children for the given node.
    """
    x,y = point.grid_point
    if x > 0 and x < len(grid) - 1:
        if y > 0 and y < len(grid[0]) - 1:
            links = [grid[d[0]][d[1]] for d in\
                     [(x-1, y),(x,y - 1),(x,y + 1),(x+1,y),\
                      (x-1, y-1), (x-1, y+1), (x+1, y-1),\
                      (x+1, y+1)]]
        elif y > 0:
            links = [grid[d[0]][d[1]] for d in\
                     [(x-1, y),(x,y - 1),(x+1,y),\
                      (x-1, y-1), (x+1, y-1)]]
        else:
            links = [grid[d[0]][d[1]] for d in\
                     [(x-1, y),(x,y + 1),(x+1,y),\
                      (x-1, y+1), (x+1, y+1)]]
    elif x > 0:
        if y > 0 and y < len(grid[0]) - 1:
            links = [grid[d[0]][d[1]] for d in\
                     [(x-1, y),(x,y - 1),(x,y + 1),\
                      (x-1, y-1), (x-1, y+1)]]
        elif y > 0:
            links = [grid[d[0]][d[1]] for d in\
                     [(x-1, y),(x,y - 1),(x-1, y-1)]]
        else:
            links = [grid[d[0]][d[1]] for d in\
                     [(x-1, y), (x,y + 1), (x-1, y+1)]]
    else:
        if y > 0 and y < len(grid[0]) - 1:
            links = [grid[d[0]][d[1]] for d in\
                     [(x+1, y),(x,y - 1),(x,y + 1),\
                      (x+1, y-1), (x+1, y+1)]]
        elif y > 0:
            links = [grid[d[0]][d[1]] for d in\
                     [(x+1, y),(x,y - 1),(x+1, y-1)]]
        else:
            links = [grid[d[0]][d[1]] for d in\
                     [(x+1, y), (x,y + 1), (x+1, y+1)]]
    return [link for link in links if link.value != 9]

def intransitable(x, y, grid):
    """
        Calcula si un punto es transitable
        Input:
            node: nodo que representa al punto
            grid: grid que se esta usando
        Output: 
            -true en caso de no ser transitable, false en caso contrario
    """
    isInside = False
    isTransitable = True
    if x > 0 and x < len(grid) - 1:
        if y > 0 and y < len(grid[0]) - 1:
            isInside = True
            #El punto es un obstaculo
            if grid[x][y].value != 1:
                isTransitable = False
    return (not isTransitable) or (not isInside)
    
def lineaDeVision(current, children, grid):
    """
        Calcula la línea de visión del algoritmo Theta*
        Input:
            current: nodo actual
            children: nodo vecino/hijo
            grid: grid en el que se trabaja
        Output:
            TODO: poner que hay que hacer aqui
    """
    x0, y0 = current.grid_point
    x1, y1 = children.grid_point
    dy = y1 - y0
    dx = x1 - x0
    f = 0
    if dy < 0:
        dy = -dy
        sy = -1
    else:
        sy = 1
    if dx < 0:
        dx = -dx
        sx = -1
    else:
        sx = 1


    if dx >= dy:
        while x0 != x1:
            f += dy
            if f >= dx:
                if intransitable(x0+((sx-1)//2),y0+((sy-1)//2),grid):
                    return False
                y0 = y0 + sy
                f = f - dx
            if f != 0 and intransitable(x0+((sx-1)//2),y0+((sy-1)//2),grid):
                return False
            if (dy == 0 and intransitable(x0+((sx-1)//2),y0,grid) and
                intransitable(x0+((sx-1)//2),y0-1,grid)):
                return False
            x0 = x0 + sx
    else:
        while y0 != y1:
            f += dx
            if f >= dy:
                if intransitable(x0+((sx-1)//2),y0+((sy-1)//2),grid):
                    return False
                x0 = x0 + sx
                f = f - dy
            if f != 0 and intransitable(x0+((sx-1)//2),y0+((sy-1)//2),grid):
                return False
            if (dx == 0 and intransitable(x0,y0+((sy-1)//2),grid) and 
                intransitable(x0-1,y0+((sy-1)//2),grid)):
                return False
            y0 = y0 + sy
    return True



#En el pseudocódigo: current == s y children == s'
def update_Vertex(current, children, grid, openset, closedset, goal, heur):
    """
        Procedimiento que actualiza la forma de llegar a un nodo a través de 
        su nodo padre o abuelo en función de la linea de visión
        Input:
            current: nodo actual
            children: nodo hijo (vecino)
            grid: grid en el que se trabaja
    """
    if lineaDeVision(current.parent,children,grid):
        new_g = current.parent.G + current.parent.move_cost(children)
        if children.G > new_g:
            children.G = new_g
            children.parent = current.parent
            #Si ya está en abiertos, lo eliminamos para volverlo a meter actualizado
            if children in openset:
                openset.remove(children)
            children.H = pp.heuristic[heur](children, goal)
            openset.add(children)
    else:
        new_g = current.G + current.move_cost(children)
        if children.G > new_g:
            children.G = new_g
            children.parent = current
            if children in openset:
                openset.remove(children)
            children.H = pp.heuristic[heur](children, goal)
            openset.add(children)

def thethaStar(start, goal, grid, heur='naive'):
    openset = set()
    closedset = set()
    start.G = 0
    start.parent = start
    current = start
    openset.add(current)
    while openset:
        current = min(openset, key=lambda o:o.G + o.H)
        pp.expanded_nodes += 1
        if current == goal:
            path = []
            while current.G != 0:
                path.append(current)
                current = current.parent
            path.append(current)
            return path[::-1]
        openset.remove(current)
        closedset.add(current)
        for node in children(current,grid):
            if node not in closedset:
                if node not in openset:
                    #Inicializamos las variables para el vecino
                    node.G = m.inf
                    node.parent = None
                update_Vertex(current, node, grid, openset, closedset, goal, heur)
    raise ValueError('No Path Found')

pp.register_search_method('Theta*', thethaStar)