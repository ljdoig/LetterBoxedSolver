open Core

let command =
  Command.basic ~summary:"Solve letter-boxed from a textfile"
    (let%map_open.Command groups = anon ("groups" %: string)
     and max_len =
       flag "max"
         (optional_with_default 3 int)
         ~doc:"INT maximum number of words in solution"
     and filename =
       flag "filename"
         (optional_with_default "corpuses/enable.txt" Filename_unix.arg_type)
         ~doc:"FILENAME filename of permitted word list"
     in
     fun () ->
       Letter_boxed.(solve ~filename ~groups ~max_len |> print_sols ~max_len))

let () = Command_unix.run ~version:"1.0" ~build_info:"letter-boxed" command
