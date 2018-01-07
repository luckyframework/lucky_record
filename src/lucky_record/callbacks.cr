module LuckyRecord::Callbacks(T)
  def prepare
  end

  def after_prepare
  end

  def before_save
  end

  def after_save(record : T)
  end
end
