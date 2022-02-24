# frozen_string_literal: true

require 'json'

target = ARGV[0]

exit 0 if target.nil?

schema_file_location_json = File.read("#{ENV['HOME']}/.graphqlrc.json")
schema_file_location = JSON.parse(schema_file_location_json)
api_version = schema_file_location['schema'].match(%r{\Ashopify_graphql_schemas/(?<api_version>.+?)\.json\z})[:api_version]
schema_json = File.read("#{ENV['HOME']}/#{schema_file_location['schema']}")
schema = JSON.parse(schema_json)

# get types
types = schema['data']['__schema']['types']

dictionaries = {}

# get plane object
# https://shopify.dev/api/admin-graphql/latest/objects/TargetObject
objects = types.select do |t|
  t['kind'] == 'OBJECT' && !t['name'].end_with?('Connection') && !t['name'].end_with?('Payload')
end
objects.each do |object|
  dictionaries.merge!(object['name'] => 'objects')
end

# get mutations
# https://shopify.dev/api/admin-graphql/latest/mutations/TargetMutation
mutations = types.find { |t| t['kind'] == 'OBJECT' && t['name'] == 'Mutation' }['fields']
mutations.each do |mutation|
  dictionaries.merge!(mutation['name'] => 'mutations')
end

# get query_roots
# https://shopify.dev/api/admin-graphql/latest/queries/TargetQuery
queries = types.find { |t| t['kind'] == 'OBJECT' && t['name'] == 'QueryRoot' }['fields']
queries.each do |query|
  dictionaries.merge!(query['name'] => 'queries')
end

# get connections
# https://shopify.dev/api/admin-graphql/latest/connections/TargetConnection
connections = types.select { |t| t['kind'] == 'OBJECT' && t['name'].end_with?('Connection') }
connections.each do |connection|
  dictionaries.merge!(connection['name'] => 'connections')
end

# get payloads
# https://shopify.dev/api/admin-graphql/latest/payloads/TargetPayload
payloads = types.select { |t| t['kind'] == 'OBJECT' && t['name'].end_with?('Payload') }
payloads.each do |payload|
  dictionaries.merge!(payload['name'] => 'payloads')
end

# get scalars
# https://shopify.dev/api/admin-graphql/latest/scalars/TargetScalar
scalars = types.select { |t| t['kind'] == 'SCALAR' }
scalars.each do |scalar|
  dictionaries.merge!(scalar['name'] => 'scalars')
end

# get enums
# https://shopify.dev/api/admin-graphql/latest/enums/TargetEnum
enums = types.select { |t| t['kind'] == 'ENUM' }
enums.each do |enum|
  dictionaries.merge!(enum['name'] => 'enums')
end

# get input_objects
# https://shopify.dev/api/admin-graphql/latest/input_objects/TargetInputObject
input_objects = types.select { |t| t['kind'] == 'INPUT_OBJECT' }
input_objects.each do |input_object|
  dictionaries.merge!(input_object['name'] => 'input_objects')
end

# get unions
# https://shopify.dev/api/admin-graphql/latest/unions/TargetUnion
unions = types.select { |t| t['kind'] == 'UNION' }
unions.each do |union|
  dictionaries.merge!(union['name'] => 'unions')
end

# get interfaces
# https://shopify.dev/api/admin-graphql/latest/interfaces/TargetInterface
interfaces = types.select { |t| t['kind'] == 'INTERFACE' }
interfaces.each do |interface|
  dictionaries.merge!(interface['name'] => 'interfaces')
end

# document_url = "https://shopify.dev/api/admin-graphql/#{api_version}/#{dictionaries[target]}/#{target}"
# `open #{document_url}`
paths = []
paths << "#{api_version}/#{dictionaries[target]}/#{target}" if dictionaries[target]

# https://shopify.dev/api/admin-graphql/2022-01/objects/AppPlanV2#field-appplanv2-pricingdetails
# https://shopify.dev/api/admin-graphql/2022-01/mutations/metafieldsSet#field-metafieldssetinput-namespace

if paths.empty?
  objects.each do |object|
    object['fields'].each do |field|
      if field['name'] == target
        paths << "#{api_version}/objects/#{object['name']}#field-#{object['name'].downcase}-#{target.downcase}"
      end
    end
  end

  mutations.each do |mutation|
    mutation['args'].each do |arg|
      if arg['name'] == target
        paths << "#{api_version}/mutations/#{mutation['name']}#args-#{mutation['name'].downcase}-#{target.downcase}"
      end
    end
  end

  queries.each do |query|
    query['args'].each do |arg|
      if arg['name'] == target
        paths << "#{api_version}/queries/#{query['name']}#args-#{query['name'].downcase}-#{target.downcase}"
      end
    end
  end

  input_objects.each do |input_object|
    input_object['inputFields'].each do |input_field|
      if input_field['name'] == target
        paths << "#{api_version}/input_objects/#{input_object['name']}#field-#{input_field['name'].downcase}-#{target.downcase}"
      end
    end
  end
end

paths.each do |path|
  puts path
end
exit 0

# shopify_graphql_schema
#
# {
#   "data": {
#     "__schema": {
#       "types": [
#         {
#           "kind": "OBJECT",
#           "name": "Mutation",
#           "fields": [
#             {
#               "name": "$target"
#             }
#           ]
#         },
#         {
#           "kind": "OBJECT",
#           "name": "QueryRoot",
#           "fields": [
#             {
#               "name": "$target"
#             }
#           ]
#         },
#         {
#           "kind": "OBJECT",
#           "name": "SomeObject",
#           "#comment": "Object",
#           "fields": [
#             {
#               "name": "$target"
#             }
#           ]
#         },
#         {
#           "kind": "OBJECT",
#           "name": "SomePayload",
#           "#comment": "Payload",
#           "fields": [
#             {
#               "name": "$target"
#             }
#           ]
#         },
#         {
#           "kind": "OBJECT",
#           "name": "SomeConnection",
#           "#comment": "Connection",
#           "fields": [
#             {
#               "name": "$target"
#             }
#           ]
#         },
#         {
#           "kind": "SCALAR",
#           "name": "$target"
#         },
#         {
#           "kind": "ENUM",
#           "name": "$target"
#         },
#         {
#           "kind": "INPUT_OBJECT",
#           "name": "$target"
#         },
#         {
#           "kind": "UNION",
#           "name": "$target"
#         },
#         {
#           "kind": "INTERFACE",
#           "name": "$target"
#         }
#       ]
#     }
#   }
# }
