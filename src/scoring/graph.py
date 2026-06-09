def find_cycle(deps: dict[str, set[str]]) -> list[str] | None:
  """Return a dependency cycle as an ordered list of node names, or None.

  ``deps`` maps each node to the set of nodes it depends on. Nodes referenced
  as a dependency but absent from ``deps`` are treated as leaves (no outgoing
  edges). The returned list traces one cycle, e.g. ``['a', 'b', 'a']``.
  """
  visited:  set[str] = set()
  in_stack: set[str] = set()

  def dfs(node: str) -> list[str] | None:
    if node in in_stack:
      return [node]
    if node in visited or node not in deps:
      return None
    in_stack.add(node)
    for dep in deps[node]:
      cycle = dfs(dep)
      if cycle is not None:
        return [node] + cycle
    in_stack.discard(node)
    visited.add(node)
    return None

  for node in deps:
    cycle = dfs(node)
    if cycle:
      return cycle
  return None
