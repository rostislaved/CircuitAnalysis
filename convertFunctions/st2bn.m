function ind = st2bn(s,t,s1,t1)
%ST2BN s and t vectors to branch number

st1 = [s(:),t(:)]; % to branches
st2 = [s1, t1];
ind = find(all( st1 == st2, 2));


end

