if !exists("g:pipe_converter_command")
  let g:pipe_converter_command = "~/.vim/bundle/pipe_converter/pipe_converter"
endif

function! PipeConvert()
  let s:line = substitute(getline('.'), '"', '\\"', 'g')
  let s:ret = system(g:pipe_converter_command . " \"". s:line. "\"")
  let s:trimed = substitute(s:ret, '\n\+', '', 'g')
  call setline('.', s:trimed)
endfunction

function! PipeRevert()
  let s:line = substitute(getline('.'), '"', '\\"', 'g')
  let s:ret = system(g:pipe_converter_command . " --revert \"". s:line. "\"")
  let s:trimed = substitute(s:ret, '\n\+', '', 'g')
  call setline('.', s:trimed)
endfunction
