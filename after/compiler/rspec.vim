if exists('current_compiler') && current_compiler ==# 'rspec'
  " Redefine errorformat so every back‑trace frame becomes a separate quickfix entry.
  setlocal errorformat=
    \\ \ \ \ \ %\\+\#\ %f:%l:%m,
    \%f:%l:\ %tarning:\ %m,
endif

" vim: nowrap sw=2 sts=2 ts=8:
