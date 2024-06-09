const connection = require('./connection.js')
const express = require('express')
const bodyParser = require('body-parser')

var app = express();
app.use(bodyParser.json())
app.get("/notes",(req,res)=>{
    connection.query('SELECT * FROM mynotes',(err,rows)=>{
        if(err){
            console.log("error: "+err)
        }else{
            res.json(rows)
            console.log(rows)
        }
    })
})
app.get("/notes/:id",(req,res)=>{
    connection.query('SELECT * FROM mynotes WHERE id=?',[req.params.id],(err,rows)=>{
        if(err){
            console.log("error: "+err)
        }else{
            res.json(rows)
            console.log(rows)
        }
    })
})
app.delete("/notes/:id",(req,res)=>{
    connection.query('DELETE FROM mynotes WHERE id=?',[req.params.id],(err,rows)=>{
        if(err){
            console.log("error: "+err)
        }else{
            res.json(rows)
            console.log(rows)
        }
    })
})
app.post("/notes",(req,res)=>{
    var postNotes = req.body
    var notesData = [postNotes.id,postNotes.notes_title,postNotes.notes_subtitle]
    connection.query('INSERT INTO mynotes(id,notes_title,notes_subtitle) VALUES(?)',[notesData],(err,rows)=>{
        if(err){
            console.log("error: "+err)
        }else{
            res.json(rows)
            console.log(rows)
        }
    })
})
app.put("/notes/:id", (req, res) => {
    const { notes_title, notes_subtitle } = req.body;
    connection.query(
        'UPDATE mynotes SET notes_title=? , notes_subtitle=? WHERE id=?',
        [notes_title,notes_subtitle, req.params.id],
        (err, result) => {
            if (err) {
                console.log("error: " + err);
                res.status(500).json({ error: 'Failed to update note.' });
            } else {
                console.log("Updated note with id: " + req.params.id);
                res.json({ message: 'Note updated successfully.' });
            }
        }
    );
});

app.listen(3000,()=>{
    console.log("app is running on 3000")
}) 