Score = Struct.new(:win, :lose, :draw) do
  def hash
    object_id ^ self.class.hash
  end
end
