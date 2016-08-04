"""Creating function wrappers for shell commands"""

import subprocess
from subprocess import CalledProcessError

PIPE = subprocess.PIPE


def command(command):
    """Create a function wrapper for a command"""
    def func(*args):
        cmd = [command]
        cmd += [str(arg) for arg in args]
        proc = subprocess.Popen(cmd, stderr=PIPE, stdout=PIPE)
        stdout, stderr = proc.communicate()
        proc.wait()
        if proc.returncode:
            raise CalledProcessError(
                returncode=proc.returncode,
                cmd=" ".join(cmd),
                output=stdout,
                stderr=stderr,
            )
    return func
