require 'ffi'
module PCI
  extend FFI::Library
  ffi_lib 'libpci'

  ACCESS_AUTO  = 0
  ACCESS_SYS_BUS_PCI = 1
  ACCESS_PROC_BUS_PCI = 2
  ACCESS_I386_TYPE1 = 3
  ACCESS_I386_TYPE2 = 4
  ACCESS_FBSD_DEVICE = 5
  ACCESS_AIX_DEVICE  = 6
  ACCESS_NBSD_LIBPCI = 7
  ACCESS_OBSD_DEVICE = 8
  ACCESS_DUMP = 9
  ACCESS_MAX = 19

  ADDR_IO_MASK = ~0x3
  ADDR_MEM_MASK = ~0xf

  FILL_IDENT = 1
  FILL_IRQ = 2
  FILL_BASES = 4
  FILL_ROM_BASE = 8
  FILL_SIZES = 16
  FILL_CLASS = 32
  FILL_RESCAN = 0x10000

  LOOKUP_VENDOR = 1
  LOOKUP_DEVICE = 2
  LOOKUP_CLASS = 4
  LOOKUP_SUBSYSTEM = 8
  LOOKUP_PROGIF = 16
  LOOKUP_NUMERIC = 0x10000
  LOOKUP_NO_NUMBERS = 0x20000
  LOOKUP_MIXED = 0x40000
  LOOKUP_NETWORK = 0x80000
  LOOKUP_SKIP_LOCAL = 0x100000
  LOOKUP_CACHE = 0x200000
  LOOKUP_REFRESH_CACHE = 0x400000

  attach_function 'pci_alloc',[],  :pointer
  attach_function 'pci_init', [ :pointer ], :void
  attach_function 'pci_cleanup', [ :pointer ], :void
  attach_function 'pci_scan_bus', [ :pointer ], :void
  attach_function 'pci_get_dev', [ :pointer, :int, :int, :int, :int ], :pointer
  attach_function 'pci_free_dev', [ :pointer ], :void
  attach_function 'pci_lookup_method', [ :pointer ], :int
  attach_function 'pci_get_method_name', [ :int ], :pointer
  attach_function 'pci_get_param', [ :pointer, :string ], :string
  attach_function 'pci_set_param', [ :pointer, :string, :string ], :int
  attach_function 'pci_walk_params', [ :pointer, :pointer], :pointer
  attach_function 'pci_read_byte', [ :pointer, :int ], :uint8
  attach_function 'pci_read_word', [ :pointer, :int ], :uint16
  attach_function 'pci_read_long', [ :pointer, :int ], :uint32
  attach_function 'pci_read_block', [ :pointer, :int, :pointer, :int ], :int
  attach_function 'pci_write_byte', [ :pointer, :int, :uint8 ], :int
  attach_function 'pci_write_word', [ :pointer, :int, :uint16 ], :int
  attach_function 'pci_write_long', [ :pointer, :int, :uint32 ], :int
  attach_function 'pci_write_block', [ :pointer, :int, :pointer, :int ], :int
  attach_function 'pci_fill_info', [ :pointer, :int ], :int
  attach_function 'pci_setup_cache', [ :pointer, :pointer, :int ], :void
  attach_function 'pci_filter_init', [ :pointer, :pointer ], :void
  attach_function 'pci_filter_parse_slot', [ :pointer, :string ], :string
  attach_function 'pci_filter_match', [ :pointer, :pointer ], :int
  attach_function 'pci_lookup_name', [ :pointer, :string, :int, :int, :varargs ], :string
  attach_function 'pci_load_name_list', [ :pointer ], :int
  attach_function 'pci_free_name_list', [ :pointer ], :void
  attach_function 'pci_set_name_list_path', [ :pointer, :string, :int ], :void
  attach_function 'pci_id_cache_flush', [ :pointer ], :void

  class Access < FFI::Struct
    layout :method,            :uint,
      :writeable,         :int,
      :buscentric,        :int,
      :id_file_name,      :string,
      :free_id_name,      :int,
      :numeric_ids,       :int,
      :id_lookup_mode,    :uint,
      :debugging,         :int,
     
      :dead1,             :pointer,
      :dead2,             :pointer,
      :dead3,             :pointer,
      
      :devices,           :pointer,
      :methods,           :pointer,
      :params,            :pointer,
      :id_hash,           :pointer,
      :current_id_bucket, :pointer,
      :id_load_failed,    :int,
      :id_cache_status,   :int,
      :fd,                :int,
      :fd_rw,             :int,
      :cached_dev,        :pointer,
      :fd_pos,            :int
  end

  class Dev < FFI::Struct
    layout :next,         :pointer,
      :domain,       :uint16,
      :bus,          :uint8,
      :dev,          :uint8,
      :func,         :uint8,
      :known_fields, :int,
      :vendor_id,    :uint16,
      :device_id,    :uint16,
      :device_class, :uint16,
      :irq,          :int,
      :base_addr,    [ :ulong, 6 ],
      :size,         [ :ulong, 6 ], 
      :rom_base_addr, :ulong,
      :rom_size,      :ulong,
      :access,       :pointer,
      :methods,      :pointer,
      :cache,        :pointer,
      :cache_len,    :int,
      :hdrtype,      :int,
      :aux,          :pointer
  end

  class Filter < FFI::Struct
    layout :domain,    :int,
      :bus,       :int,
      :slot,      :int,
      :func,      :int,
      :vendor,    :int,
      :device,    :int
  end
end
