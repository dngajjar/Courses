function  [min_energy, seam] = findSeam_horizontal(G)
%%FINDSEAM_horizontal function is just the transposing the arguments of the findSeam_vertical function

[min_energy, seam] = findSeam_vertical(G');
end
    
    




