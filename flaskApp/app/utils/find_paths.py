# Given start and end position, find all possible routes from start to end, return list of JSON objects
def find_all_paths(graph, start, end, path=None, path_distance=0):
    if path is None:
        path = {'route': [], 'route_distance': 0} 

    path['route'] = path['route'] + [start]

    if start == end:
        return [path]
    if start not in graph:
        return []
    paths = []

    for connection in graph[start]:  # Iterate over connections (which are dicts)
        connection_distance = graph[start][connection]

        if connection not in path['route']:  # Avoid cycles
            new_path = {'route': path['route'], 'route_distance': path['route_distance'] + connection_distance}
            paths.extend(find_all_paths(graph, connection, end, new_path))

    return paths