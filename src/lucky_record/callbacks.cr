module LuckyRecord::Callbacks(T)
  macro included
    @@prepare_callbacks = [] of Proc(Nil)
    @@after_prepare_callbacks = [] of Proc(Nil)
    @@before_save_callbacks = [] of Proc(Nil)
    @@after_save_callbacks = [] of Proc(T)
  end

  def self.prepare(&block)
    @@prepare_callbacks << block
  end

  def prepare
    @@prepare_callbacks.each(&.call)
  end

  def self.after_prepare(&block)
    @@after_prepare_callbacks << block
  end

  def after_prepare
    @@after_prepare_callbacks.each(&.call)
  end

  def self.before_save(&block)
    @@before_save_callbacks << block
  end

  def before_save
    @@before_save_callbacks.each(&.call)
  end

  def self.after_save(&block)
    @@after_save_callbacks << block
  end

  def after_save(record : T)
    @@after_save_callbacks.each(&.call(record))
  end
end
