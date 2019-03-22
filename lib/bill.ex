defmodule Bill do

    def print_bill(month, year, number, key) do
        subscriber = Subscriber.find_by_number(number, key)
        calls_month = find_elements_by_month(subscriber.calls, month, year)
        cond do 
            key == :pre ->
                recharges_month = find_elements_by_month(subscriber.plan.recharges, month, year)
                plan = %Prepaid{subscriber.plan | recharges: recharges_month} 
                %Subscriber{ subscriber | calls: calls_month, plan: plan}
            key == :post ->
                %Subscriber{subscriber | calls: calls_month}        
        end
    end

    def find_elements_by_month(elements, month, year) do
        Enum.filter elements, &(&1.date.year == year and &1.date.month == month)
    end

end