class Vertex
  
  attr_accessor :obj
  
  def initialize(obj)
    @obj = obj
  end
  
  def inspect
    @obj.inspect
  end
  
end

class Edge
  
  attr_accessor :from, :to
  
  def initialize(from, to)
    @from = from
    @to = to
  end
  
end

class Graph
  
  attr_accessor :vertices, :edges
  
  def initialize
    @vertices = []
    @edges = {}
  end
  
  def inspect
    result = ""
    @vertices.each do |v|
      result << v.inspect
      if @edges[v] and @edges[v].length > 0
        result << " : " 
        result << @edges[v].inject("") do |res, e| 
          res << e.to.inspect 
          res << "(#{e.res_capacity})" if e.respond_to?(:res_capacity)
          res << "; " 
        end
      end
      result << "\n\n"
    end
    result
  end
  
  # Returns vertex representing obj
  def find(obj)
    @vertices.find { |v| v.obj == obj }
  end
  
  # Retunrs all edges in the graph
  def all_edges
    @edges.values.inject { |arr1, arr2| arr1 + arr2 } || []
  end
  
  # Adds a vertex to the graph
  def add_vertex(v)
    @vertices << v
    @edges[v] = []
  end
  
  # Adds an edge to the graph
  def add_edge(e)
    @edges[e.from] << e
  end
  
  # If the graph is a bi-graph finds its maximal matching. 
  def max_matching(left, right)
    g = Graph.new
    left.each do |v|
      g.add_vertex v
    end
    right.each do |v|
      g.add_vertex v
    end
    source = Vertex.new "source"
    g.add_vertex source
    sink = Vertex.new "sink"
    g.add_vertex sink
    capacity_table = {
      source => {},
      sink => {}
    }
    left.each do |v| 
      g.add_edge Edge.new(source, v)
      capacity_table[source][v] = 1
      capacity_table[v] ||= {}
    end
    right.each do |v|
      g.add_edge Edge.new(v, sink)
      capacity_table[v] ||= {}
      capacity_table[v][sink] = 1
    end
    left.each do |v1|
      right.each do |v2|
        edge = @edges[v1].find { |e| e.to == v2 }
        if edge
          g.add_edge Edge.new(v1, v2)
          capacity_table[v1] ||= {}
          capacity_table[v1][v2] = 1
        end
      end
    end
    flow_table = g.max_flow(source, sink, capacity_table)
    flow_table.delete source
    flow_table.delete sink
    result = []
    flow_table.keys.each do |v1|
      flow_table[v1].delete sink
      flow_table[v1].keys.each do |v2|
        result << [v1, v2] if flow_table[v1][v2] == 1
      end
    end
    result
  end
  
  # Source and sink must be in @vertices.
  def max_flow(source, sink, capacity_table)
    flow_table = all_edges.inject({}) do |table, e| 
      table[e.from] ||= {}
      table[e.to] ||= {}
      table[e.from][e.to] = 0
      table[e.to][e.from] = 0
      table
    end
    residual = create_res_graph(capacity_table, flow_table)
    while path = residual.path(source, sink)
      min = residual.min_res_capacity_at_path path
      path.inject do |pred, succ|
        flow_table[pred][succ] += min
        flow_table[succ][pred] = -flow_table[pred][succ]
        edge = residual.edges[pred].find { |e| e.to == succ }
        edge.res_capacity -= min
        if edge.res_capacity == 0
          residual.edges[pred].delete edge
          res_capacity = capacity_table[succ][pred].to_i - flow_table[succ][pred]
          residual.create_res_edge(succ, pred, res_capacity) if res_capacity > 0
        end
        succ
      end
    end
    flow_table
  end
  
  # Finds a path from "from" to "to" using BFS. Returns nil if no path exists.
  def path(from, to)
    prev = bfs(from)[0]
    return nil unless prev[to]
    rev_path = []
    current_vertex = to
    while current_vertex
      rev_path << current_vertex
      current_vertex = prev[current_vertex]
    end
    rev_path.reverse
  end
  
  # Performs breadth-first-search. Returns a hash with predecessors and a hash
  # with calculated distances from "source" vertex.
  def bfs(source)
    color = {}
    prev = {}
    dist = {}
    @vertices.each do |v|
      color[v] = "white"
      prev[v] = nil
      dist[v] = -1
    end
    color[source] = "grey"
    dist[source] = 0
    queue = []
    queue.push source
    while !queue.empty?
      v = queue.pop
      (@edges[v] || []).each do |edge|
        adj = edge.to
        if color[adj] == "white"
          color[adj] = "grey"
          dist[adj] = dist[v] + 1
          prev[adj] = v
          queue.push adj
        end
      end
      color[v] = "black"
    end
    [prev, dist]
  end
  
  # Creates residual graph.
  def create_res_graph(capacity_table, flow_table)
    result = Graph.new
    result.vertices = @vertices.dup
    @vertices.each do |v1|
      @vertices.each do |v2|
        residual_capacity = capacity_table[v1][v2].to_i - flow_table[v1][v2].to_i
        result.create_res_edge(v1, v2, residual_capacity) if residual_capacity > 0
      end
    end
    result
  end

  # Creates an edge in residual graph.
  def create_res_edge(from, to, res_capacity)
    edge = Edge.new(from, to)
    class << edge; class_eval "attr_accessor :res_capacity"; end
    edge.res_capacity = res_capacity
    @edges[from] ||= []
    @edges[from] << edge
  end

  # Returns minimum residual capacity at given path.
  def min_res_capacity_at_path(path)
    min = nil
    path.inject do |pred, succ|
      edge = @edges[pred].select { |e| e.to == succ }.first
      min = edge.res_capacity if min.nil? or min > edge.res_capacity
      succ
    end
    min
  end
  
end