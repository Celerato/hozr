# encoding: UTF-8

class DropTablePages < ActiveRecord::Migration
  def self.up
    drop_table :pages
  end

  def self.down
  end
end
