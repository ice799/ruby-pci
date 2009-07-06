require 'rubygems'
require 'ffi'
require 'ruby-pci'

pacc = PCI.pci_alloc
PCI.pci_init(pacc)
PCI.pci_scan_bus(pacc)
pacc = PCI::Access.new(pacc)
dev = pacc[:devices]

while true
  dev = PCI::Dev.new(dev)
  PCI.pci_fill_info(dev, PCI::FILL_IDENT | PCI::FILL_BASES)
  if dev[:vendor_id] == 0x8086
    type = PCI.pci_read_byte(dev, 0x0e)
    puts "found an intel pci bridge!" if type == 1
  end
  dev = dev[:next]
  break if dev.null?
end
