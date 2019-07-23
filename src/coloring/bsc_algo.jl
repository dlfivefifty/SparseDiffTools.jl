<<<<<<< HEAD
#bsc 1-based indexing
using LightGraphs

function color_graph(g::LightGraphs.AbstractGraph)

    #number of vertices in g
    v = nv(g)

    #A is order of vertices in non-increasing order of degree
    A = sort_by_degree(g)

    #F is the coloring of vertices, 0 means uncolored
    #Fopt is the optimal coloring of the graph
    F = zeros(Int32, v)
    Fopt= zeros(Int32, v)

    #start index
=======
"""
    BSCColor

    Backtracking Sequential Coloring algorithm
"""
function color_graph(G::VSafeGraph,::BSCColor)
    V = nv(G)
    F = zeros(Int, V)
    freeColors = [Vector{Int}() for _ in 1:V] #set of free colors for each vertex
    U = zeros(Int, 0) #stores set of free colors
    #F = zeros(Int, 0) #stores final coloring of vertices

    sorted_vertices = order_by_degree(G)
>>>>>>> 1b115b8d6dd386c46a0474c736e91aae710afd3d
    start = 1

    #optimal color number
    opt = v + 1

    #current vertex to be colored
    x = A[1]

    #colors[j] = number of colors in A[0]...A[j]
    #assume colors[0] = 1
    colors = zeros(Int32, v)

    #set of free colors
    U = zeros(Int32, 0)
    push!(U, 1)

    #set of free colors of x
    freeColors = [Vector{Int64}() for _ in 1:v]
    freeColors[x] = copy(U)

    while (start >= 1)

        back = false
        for i = start:v
            if i > start
                x = uncolored_vertex_of_maximal_degree(A,F)
                U = free_colors(x, A, colors, F, g, opt)
                sort!(U)
            end
            if length(U) > 0
                k = U[1]
                F[x] = k
                deleteat!(U, 1)
                freeColors[x] = copy(U)
                if i==1
                    l = 0
                else
                    l = colors[i-1]
                colors[i] = max(k, l)
                end
            else
                start = i-1
                back = true
                break
            end
        end
        if back
            if start >= 1
                x = A[start]
                F[x] = 0
                U = freeColors[x]
            end
        else
            Fopt = copy(F)
            opt = colors[v-1]
            i = least_index(F,A,opt)
            start = i-1
            if start < 1
                break
            end

            #uncolor all vertices A[i] with i >= start
            uncolor_all!(F, A, start)

            #try start+1 instead
            for i = 1:start+1
                x = A[i]
                U = freeColors[x]
                #remove colors >= opt from U
                U = remove_higher_colors(U, opt)
                freeColors[x] = copy(U)
            end
        end

    end

    F
end


<<<<<<< HEAD
function sort_by_degree(g::LightGraphs.AbstractGraph)
    vs = vertices(g)
    degrees = (LightGraphs.degree(g, v) for v in vs)
    vertex_pairs = collect(zip(vs, degrees))
    sort!(vertex_pairs, by = p -> p[2], rev = true)
    [v[1] for v in vertex_pairs]
end


function uncolored_vertex_of_maximal_degree(A,F)
    for v in A
        if F[v] == 0
            return v
=======
Find the degree of the vertex z which belongs to the graph G.
"""
function degree(G::VSafeGraph,z::Int)
    return length(inneighbors(G,z))
end


function sorted_vertices(G::VSafeGraph)
    V = nv(G)
    marked = zeros(Int,V)
    sv = zeros(Int,0)
    max_degree = -1
    max_degree_vertex = -1
    for i = 1:V
        max_degree = -1
        max_degree_vertex = -1
        for j = 1:V
            if j != i
                if degree(G,j) > max_degree && marked[j] == 0
                    max_degree = degree(G,j)
                    max_degree_vertex = j
                end
            end
>>>>>>> 1b115b8d6dd386c46a0474c736e91aae710afd3d
        end
    end
end

<<<<<<< HEAD

function free_colors(x, A, colors, F, g, opt)
    index = -1

    freecolors = zeros(Int64, 0)

    for i in eachindex(A)
        if A[i] == x
            index = i
            break
=======
#find uncolored vertex of maximal degree of saturation
function find_uncolored_vertex(sv::Array{Int,1}, G::VSafeGraph)
    colors = zeros(Int,0)
    max_colors = -1
    max_color_index = -1
    for i = 1:nv(G)
        if F[i] != 0
            for j in inneighbors(G,i)
                if F[j] != 0 && F[j] in colors == false
                    push!(colors, F[j])
                end
            end
            if length(colors) > max_colors
                max_colors = length(colors)
                max_color_index = i
            end
        end
        colors = zeros(Int,0)
    end
    for i = 1:nv(G)
        if A[i] == max_color_index
            return i
>>>>>>> 1b115b8d6dd386c46a0474c736e91aae710afd3d
        end
    end

    if index == 1
        colors_used = 0
    else
        colors_used = colors[index-1]
    end

<<<<<<< HEAD
    colors_used += 1
    for c = 1:colors_used
        c_allowed = true
        for w in inneighbors(g, x)
            if F[w] == c
                c_allowed = false
=======
#set of free colors of x, which are < optColorNumber
function free_colors(x::Int, F::Array{Int,1}, G::VSafeGraph, max_color::Int)
    colors = zeros(Int,0)
    for color in 1:max_color
        present = true
        for y in inneighbors(G,x)
            if F[y] == color
                present = false
>>>>>>> 1b115b8d6dd386c46a0474c736e91aae710afd3d
                break
            end
        end
        if c_allowed && c < ocn
            push!(freecolors, c)
        end
    end

    freecolors

end

<<<<<<< HEAD
function least_index(F,A,opt)
    for i in eachindex(A)
        if F[A[i]] == opt
=======
#least index with F(A[i]) = optColorNumber
function least_index(A::Array{Int, 1}, F::Array{Int,1}, optColorNumber::Int, G::VSafeGraph)
    for i = 1:nv(G)
        if F[A[i]] == optColorNumber
>>>>>>> 1b115b8d6dd386c46a0474c736e91aae710afd3d
            return i
        end
    end
end

<<<<<<< HEAD
function uncolor_all!(F, A, start)
    for i = start:length(A)
=======
#uncolor all vertices A[i] with i >= start
function uncolor_all(F::Array{Int,1}, A::Array{Int,1}, start::Int, G::VSafeGraph)
    for i = start:nv(G)
>>>>>>> 1b115b8d6dd386c46a0474c736e91aae710afd3d
        F[A[i]] = 0
    end
end

<<<<<<< HEAD

function remove_higher_colors(U, opt)
    u = zeros(Int32, 0)
    for color in U
        if color < opt
            push!(u, color)
=======
#remove from U all colors >= optColorNumber
function remove_colors(U::Array{Int,1}, optColorNumber::Int)
    modified_U = zeros(Int,0)
    for i = 1:length(U)
        if U[i] < optColorNumber
            push!(mmodified_U, U[i])
>>>>>>> 1b115b8d6dd386c46a0474c736e91aae710afd3d
        end
    end
end
