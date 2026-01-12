module ButtonHelper
  def button_group_classes(index, length)
    klass = []
    # If the button is the first or last (or both if it's the only one), add rounded corners
    klass << "rounded-s-lg" if index == 0
    klass << "rounded-e-lg" if index == length - 1

    # If the button isn't on either end, it's in the middle with it's own special classes
    klass = [ "border-t", "border-b" ] if klass.empty?

    klass.join(" ")
  end

  def button_base_classes
    "px-4 py-2 text-sm font-normal text-white bg-slate-800 border border-slate-700 cursor-pointer " \
    "hover:bg-slate-600 focus:ring-blue-500 focus:z-10 focus:ring-2"
  end
end
