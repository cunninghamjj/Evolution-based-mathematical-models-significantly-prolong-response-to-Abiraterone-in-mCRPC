function [u] = createU(dataTimes, binaryAbi)

for i = 2:1:size(dataTimes, 1)
    
    u(floor(dataTimes(i-1)) + 1:floor(dataTimes(i))) = binaryAbi(i-1);
    
end

end
