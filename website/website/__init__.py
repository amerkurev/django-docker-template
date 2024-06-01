from typing import List, Optional

TRUE = ("1", "true", "True", "TRUE", "on", "yes")


def is_true(val: Optional[str]) -> bool:
    return val in TRUE


def split_with_comma(val: str) -> List[str]:
    return list(filter(None, map(str.strip, val.split(","))))
