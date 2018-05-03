function a = fnCDtoAlpha( cd, rgAlpha, rgCD )
    ia = find( rgCD < cd, 1 ) - 1;
    
    if isempty( ia )
        a = rgAlpha( end );
    elseif ia == 0
        a = rgAlpha(1);
    else
        m = ( rgAlpha( ia + 1 ) - rgAlpha( ia ) ) / ( rgCD( ia + 1 ) - rgCD( ia ) );
        a = m * ( cd - rgCD( ia ) ) + rgAlpha( ia );
    end
    
end