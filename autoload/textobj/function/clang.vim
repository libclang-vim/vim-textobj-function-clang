let g:textobj_function_clang_default_compiler_args = get(g:, 'textobj_function_clang_default_compiler_args', "")
let g:textobj_funciton_clang_include_headers = get(g:, 'textobj_funciton_clang_include_headers', "")

function! s:prepare_temp_file()
    if g:textobj_funciton_clang_include_headers
        let temp_name = expand('%:p:h') . substitute(tempname(), '\W', '_', 'g') . (&filetype ==# 'c' ? '.c' : '.cpp')
        call writefile(getline(1, '$'), temp_name)
    else
        let temp_name = tempname() . (&filetype ==# 'c' ? '.c' : '.cpp')
        call writefile(map(getline(1, '$'), 'v:val =~# "^\\s*#include\\s*\\(<[^>]\\+>\\|\"[^\"]\\+\"\\)" ? "" : v:val'), temp_name)
    endif

    return temp_name
endfunction

function! textobj#function#clang#select(obj)
    let temp_name = s:prepare_temp_file()
    try
        let extent = libclang#location#function_extent(temp_name, line('.'), col('.'), get(b:, 'textobj_function_clang_default_compiler_args', g:textobj_function_clang_default_compiler_args))
    finally
        call delete(temp_name)
    endtry
    if empty(extent) || extent.start.file !=# extent.end.file
        return 0
    endif
    let pos = getpos('.')
    let start = [pos[0], extent.start.line, extent.start.column, pos[3]]
    let end = [pos[0], extent.end.line, extent.end.column, pos[3]]
    return [( a:obj ==# 'i' ? 'v' : 'V'), start, end]
endfunction

