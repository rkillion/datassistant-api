puts "Seeding..."

BaseType.create(
    title_singular: "Text Field",
    title_plural: "Text Fields",
    value_type: "string"
)

BaseType.create(
    title_singular: "Number Field",
    title_plural: "Number Fields",
    value_type: "number"
)

BaseType.create(
    title_singular: "True-False Field",
    title_plural: "True-False Fields",
    value_type: "boolean"
)

puts "Done seeding!"