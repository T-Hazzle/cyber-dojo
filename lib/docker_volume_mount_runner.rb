
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/
# and relying on docker volume mounts on host to
# give /katas/ state access to docker process containers.
#
# Comments at end of file

require_relative './docker_times_out_runner'
require 'tempfile'

class DockerVolumeMountRunner

  def initialize(bash = Bash.new, cid_filename = Tempfile.new('cyber-dojo').path)
    @bash = bash
    @cid_filename = cid_filename
    raise_if_docker_not_installed
  end

  def run(sandbox, command, max_seconds)
    read_write = 'rw'
    sandbox_volume = "#{sandbox.path}:/sandbox:#{read_write}"
    options =
        ' --net=none' +
        " -v #{quoted(sandbox_volume)}" +
        ' -w /sandbox'
    language = sandbox.avatar.kata.language
    cmd = timeout(command, max_seconds)
    times_out_run(options, language.image_name, cmd, max_seconds)
  end

  private

  include DockerTimesOutRunner

end


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# "docker run" +
#    ' --net=none' +
#    " -v #{quoted(sandbox_volume)}" +
#    " -w /sandbox" +
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# --net=none
#
#   Turn off all networking inside the container.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# -v #{quoted(sandbox_volume)}
#
#   Volume mount the animal's sandbox to /sandbox inside the docker
#   container as a read-write folder. This provides isolation.
#   Important to quote the volume incase any paths contain spaces
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# -w /sandbox
#
#   Working directory when the command is run is /sandbox
#   (as volume mounted in the first -v option)
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

