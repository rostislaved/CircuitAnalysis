function str = numFormat(value)

if value > 1000 | value < 0.1
    str = '%1.1e';
else
    str = '%1.1f';
end
str = sprintf(str,value);

end

