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
    "px-4 py-2 text-sm font-medium text-gray-900 bg-white border border-gray-200 cursor-pointer " \
    "hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700 " \
    "dark:bg-gray-800 dark:border-gray-700 dark:text-white dark:hover:text-white dark:hover:bg-gray-700 " \
    "dark:focus:ring-blue-500 dark:focus:text-white"
  end
end
