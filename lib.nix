{

  listFilePaths =
    path:
    let
      entries = readDir path;
    in
    foldl' (acc: name: if entries.${name} == "regular" then acc ++ [ "${path}/${name}" ] else acc) [ ] (
      attrNames entries
    );
}
