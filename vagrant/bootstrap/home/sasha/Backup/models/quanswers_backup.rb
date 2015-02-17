# encoding: utf-8

##
# Backup Generated: quanswers_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t quanswers_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://meskyanichi.github.io/backup
#
Model.new(:quanswers_backup, 'Description for quanswers_backup') do

  ##
  # PostgreSQL [Database]
  #
  database PostgreSQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = "quanswers"
    db.username           = "sasha"
    # db.password           = ""
    db.host               = "localhost"
    db.port               = 5432
    db.socket             = "/tmp/pg.sock"
    # When dumping all databases, `skip_tables` and `only_tables` are ignored.
    # db.skip_tables        = ["skip", "these", "tables"]
    # db.only_tables        = ["only", "these", "tables"]
    db.additional_options = ["-xc", "-E=utf8"]
  end

  ##
  # Local (Copy) [Storage]
  #
  store_with Local do |local|
    local.path       = "~/backups/"
    local.keep       = 5
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

end