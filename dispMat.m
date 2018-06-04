function dispMat(M)

M2 = unique(M)';
hold on
for i = 1:length(M2)
   cM2 = M2(i);
   [I,J] = ind2sub(size(M),find(M == cM2));
   plot(J,-I,'.','MarkerSize',10)
end
hold off

end

