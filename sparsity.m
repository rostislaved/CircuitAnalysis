function s = sparsity(m)

s = 1 - nnz(m)/numel(m);