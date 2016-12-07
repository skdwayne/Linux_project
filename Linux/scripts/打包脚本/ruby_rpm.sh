#!/bin/bash

echo 'export PATH=/application/ruby-2.3.0/bin:$PATH' >>/etc/profile

PATH=/application/ruby-2.3.0/bin:$PATH
export PATH   ##测试一下

#export PATH=/application/ruby-2.3.0/bin:$PATH

ln -s /application/ruby-2.3.0/ /application/ruby
