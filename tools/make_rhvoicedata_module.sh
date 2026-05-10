#!/bin/bash
# Script to create rhvoicedata module

echo "Creating rhvoicedata module..."

# Create a dummy tar.xz file as placeholder
mkdir -p /tmp/rhvoicedata
touch /tmp/rhvoicedata/.placeholder
tar -cJf rhvoicedata.tar.xz -C /tmp rhvoicedata

echo "Module created successfully."
