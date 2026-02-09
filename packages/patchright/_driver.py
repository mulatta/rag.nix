import os
import sys
from typing import Tuple

from patchright._repo_version import version


def compute_driver_executable() -> Tuple[str, str]:
    return "@node@", "@driver@"


def get_driver_env() -> dict:
    env = os.environ.copy()
    env["PW_LANG_NAME"] = "python"
    env["PW_LANG_NAME_VERSION"] = f"{sys.version_info.major}.{sys.version_info.minor}"
    env["PW_CLI_DISPLAY_VERSION"] = version
    return env
