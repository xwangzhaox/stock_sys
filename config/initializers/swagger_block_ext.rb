Swagger::Blocks::Nodes::OperationNode.class_eval do
  def parameter_id
    parameter do
      key :name, :id
      key :type, :integer
      key :in, :path
      key :required, true
    end
  end

  def simple_parameter(name, type, format: nil, _in: :formData, required:, description: nil, default: nil, items_input: nil)
    parameter do
      key :name, name
      key :type, type
      key :format, format if format
      key :in, _in
      key :required, required
      key :description, description if description
      key :default, default if default || default == false
      items { key :'$ref', items_input } if items_input
    end
  end

  def pagination_parameters
    simple_parameter :page, :integer, _in: :query, required: false, description: '第几页，默认是1'
    simple_parameter :per_page, :integer, _in: :query, required: false, description: "每页多少条数据，默认是#{Kaminari.config.default_per_page}"
  end
end
