function love.conf(t)
    t.releases = {
        title = "Template",              -- The project title (string)
        package = "pack-template",       -- The project command and package name (string)
        loveVersion = nil,               -- The project LÖVE version
        version = "0.0",                 -- The project version
        author = "template",             -- Your name (string)
        email = "template",              -- Your email (string)
        description = "template",        -- The project description (string)
        homepage = "template.temp",      -- The project homepage (string)
        identifier = "public.item",      -- The project Uniform Type Identifier (string)
        excludeFileList = {},            -- File patterns to exclude. (string list)
        releaseDirectory = "release",    -- Where to store the project releases (string)
    }
	t.console = true
end
