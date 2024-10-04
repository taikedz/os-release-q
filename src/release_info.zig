pub const LineError = error {
    NotFound,
    NotValid
};

pub const OsInfo = struct {
    id:[]u8,
    version_id:[]u8,
    pretty_name:[]u8,
    id_like:[]u8,

    alloc:std.mem.Allocator,

    fn init(self:*OsInfo, alloc:std.head.Allocator, ) OsInfo {
        self.alloc = alloc;
        return self;
    },

    fn deinit(self:*OsInfo) {
        _ = self.alloc.free(self.id);
        _ = self.alloc.free(self.version_id);
        _ = self.alloc.free(self.pretty_name);
        _ = self.alloc.free(self.id_like);
    }
}

pub fn extract_release_info(alloc:std.head.Allocator, lines:std.ArrayList) LineError!OsInfo {
    // All the following are slices into `lines` values
    const id          = _find_value("ID", lines);
    const version_id  = _find_value("VERSION_ID", lines);

    const pretty_name = _find_value_defaulting("PRETTY_NAME", lines, version_id ++ " " ++ id);
    const id_like     = _find_value_defaulting("ID_LIKE", lines, id);

    // FIXME - this needs to somehow do mem copying into the OsInfo bc otherwise it
    //         must outlive `lines` - which we cannot guarantee from here.
    //         Also, pretty_name can be a stack value if not found in the file
    return OsInfo.init(alloc){ id:id, version_id:version_id, pretty_name:pretty_name, id_like:id_like };

}

fn _find_value(key:[]u8, lines:std.ArrayList) LineError![]u8 {
    for(lines) |line| {
        // if not "=" , return LineError.NotValid
        // get slices left and right of "="
        // if left == key, return right
    }

    return LineError.NotFound;
}

fn _find_value_defaulting(key: []u8, lines:std.ArrayList, default:[]u8) LineError.NotValid![]u8 {
    return _find_value(key, lines) catch default ;
}

