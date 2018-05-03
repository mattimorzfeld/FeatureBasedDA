function s = fnCDtoSD( cd, rgCD, rgSD )
    icd = find( rgCD < cd, 1 ) - 1;
    
    if isempty( icd )
        s = rgSD( end );
    elseif icd == 0
        s = rgSD( 1 );
    else
        p = ( rgCD( icd ) - cd ) / ( rgCD( icd ) - rgCD( icd + 1 ) );
        s = p*rgSD( icd + 1 ) + ( 1 - p )*rgSD( icd );
    end
end