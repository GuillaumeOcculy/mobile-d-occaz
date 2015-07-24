module ApplicationHelper

	def print_amount(amount)
		if amount.to_f == amount.round(0)
			format("%d€", amount)
		else
			format("%.2f€", amount)
		end
	end

	def print_boolean(value)
		if value
			'Oui'
		else
			'Non'
		end
	end

	def print_state(value)
		case value
			when 0
				'Mauvais'
			when 1
				'Moyen'
			when 2
				'Mediocre'
			when 3
				'Bon'
			when 4
				'Neuf'
		end
	end

end
