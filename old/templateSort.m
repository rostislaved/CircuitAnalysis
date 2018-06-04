function [E2] = templateSort(E1, st1, st2)

E1 = E1(:);
[r1 c1] = size(st1);
[r2 c2] = size(st2);
if r1 < c1
    st1 = st1';
end

if r2 < c2
    st2 = st2';
end

if length(E1) ~= length(st1) ||...
   length(E1) ~= length(st2)
   error('Inputs are of different lengths')
end

E2 = zeros(length(E1),1);
if 0
    % Slow but does not require much memory
    for i = 1:length(E2)
       ind = find(all( st1 == st2(i,:) , 2 ));
       E2(i) = E1(ind);   
    end
else
    % Much faster but require some memory
    [~,index] = ismember(st2, st1, 'row');
    E2 = E1(index);
end

end