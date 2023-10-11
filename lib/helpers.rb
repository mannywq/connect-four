module Helpers
  def prompt(*args)
    print(*args)
    gets.chomp
  end
end
