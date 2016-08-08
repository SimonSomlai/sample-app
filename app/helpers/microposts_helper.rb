module MicropostsHelper
	def micropost_params
		# Filters the hash that's passed through the create action! Make sure it's for micropost resource and get only the attribute content
		params.require(:micropost).permit(:content, :user, :picture)
	end
end
