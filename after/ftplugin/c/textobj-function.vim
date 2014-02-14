function! g:textobj_function_c_select(obj)
    return textobj#function#clang#select(a:obj)
endfunction

let b:textobj_function_select = function('g:textobj_function_c_select')

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'unlet b:textobj_function_select'
