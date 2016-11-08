function! PipeConvert()
  let line = substitute(getline('.'), '"', '\\"', 'g')
  let ret = system("~/.vim/bundle/pipe_converter/pipe_converter \"". line. "\"")
  let trimed = substitute(ret, '\n\+', '', 'g')
  call setline('.', trimed)
endfunction

function! PipeRevert()
  let line = substitute(getline('.'), '"', '\\"', 'g')
  let ret = system("~/.vim/bundle/pipe_converter/pipe_converter --revert \"". line. "\"")
  let trimed = substitute(ret, '\n\+', '', 'g')
  call setline('.', trimed)
endfunction
