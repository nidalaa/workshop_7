class StoryStorage
  @data = { stories:
                [ { id: "1", title: "Lorem ipsum", url: "http://www.lipsum.com/" },
                { id: "2", title: "Lorem", url: "http://www.lorem.com/" } ]
            }

  def self.all_stories
    { stories:
                [ { id: "1", title: "Lorem ipsum", url: "http://www.lipsum.com/" },
                { id: "2", title: "Lorem", url: "http://www.lorem.com/" } ]
            }
  end

  def self.find_story(id)
    @data[:stories].select { |story| story[:id] == id }.first
  end
end
