shared_examples :clearance_batch_creator do

  context "total success" do

    it "should allow a user to upload a new clearance batch successfully" do
      items = 5.times.map{ FactoryGirl.create(:item) }
      visit "/clearance_batches/new"
      submit_batch(items)
      new_batch = ClearanceBatch.first
      expect(page).to have_content("#{items.count} items clearanced in batch #{new_batch.id}")
      expect(page).not_to have_content("item ids raised errors and were not clearanced")
      within('table.clearance_batches') do
        expect(page).to have_content(/Clearance Batch \d+/)
      end
    end
  end

  context "partial success" do

    it "should allow a user to upload a new clearance batch partially successfully, and report on errors" do
      valid_items   = 3.times.map{ FactoryGirl.create(:item) }
      invalid_items = [[987654], ['bogus']]
      visit "/clearance_batches/new"
      submit_batch(valid_items + invalid_items)
      new_batch = ClearanceBatch.first
      expect(page).to have_content("#{valid_items.count} items clearanced in batch #{new_batch.id}")
      expect(page).to have_content("#{invalid_items.count} item ids raised errors and were not clearanced")
      within('table.clearance_batches') do
        expect(page).to have_content(/Clearance Batch \d+/)
      end
    end
  end

  context "total failure" do

    it "should allow a user to upload a new clearance batch that totally fails to be clearanced" do
      invalid_items = [[987654], ['bogus']]
      visit "/clearance_batches/new"
      submit_batch(invalid_items)
      expect(page).not_to have_content("items clearanced in batch")
      expect(page).to have_content("No new clearance batch was added")
      expect(page).to have_content("#{invalid_items.count} item ids raised errors and were not clearanced")
      within('table.clearance_batches') do
        expect(page).not_to have_content(/Clearance Batch \d+/)
      end
    end
  end
end
