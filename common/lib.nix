{

  # filterListByAttrKeys = list: keysToFilter: builtins.filter (item: builtins.any (key: builtins.hasAttr key item) keysToFilter) list;
  zipWithFilteredAttrKeys = list: keysToFilter: (builtins.zipAttrsWith (name: values: builtins.head values))
	(builtins.filter (item: builtins.any (key: builtins.hasAttr key item) keysToFilter) list);

}

